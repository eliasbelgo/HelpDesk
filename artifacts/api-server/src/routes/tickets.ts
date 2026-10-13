import { Router, type IRouter } from "express";
import { db, ticketsTable, departmentsTable, commentsTable, usersTable, type Ticket } from "@workspace/db";
import { eq, sql, and, desc } from "drizzle-orm";
import { requireAuth } from "../auth/middleware";
import { canAccessTicket } from "../auth/access";

const router: IRouter = Router();

const TICKET_PRIORITIES = ["low", "medium", "high", "urgent"] as const;
type TicketPriority = (typeof TICKET_PRIORITIES)[number];

/** E-07: el listado se pagina (por defecto 50 tickets, máximo 200 por petición). */
const DEFAULT_PAGE_SIZE = 50;
const MAX_PAGE_SIZE = 200;

router.use(requireAuth);

router.get("/tickets", async (req, res) => {
  try {
    const user = req.authUser!;
    const { departmentId, status, priority, createdBy } = req.query;

    const conditions = [];

    /** Empleado: solo tickets con created_by = nombre del usuario (normalizado). Admin/supervisor: sin filtro de filas. */
    if (user.role === "employee") {
      conditions.push(sql`lower(trim(${ticketsTable.createdBy})) = ${user.name.trim().toLowerCase()}`);
    }

    if (user.role === "admin" || user.role === "manager") {
      if (departmentId) conditions.push(eq(ticketsTable.departmentId, parseInt(departmentId as string)));
      if (createdBy) conditions.push(eq(ticketsTable.createdBy, createdBy as string));
    }
    if (status) conditions.push(eq(ticketsTable.status, status as "open" | "in_progress" | "resolved" | "closed"));
    if (priority) conditions.push(eq(ticketsTable.priority, priority as "low" | "medium" | "high" | "urgent"));

    const whereExpr =
      conditions.length > 0
        ? conditions.length === 1
          ? conditions[0]
          : and(...conditions)
        : undefined;

    const limitRaw = parseInt(String(req.query.limit ?? ""), 10);
    const offsetRaw = parseInt(String(req.query.offset ?? ""), 10);
    const limit =
      Number.isFinite(limitRaw) && limitRaw > 0 ? Math.min(limitRaw, MAX_PAGE_SIZE) : DEFAULT_PAGE_SIZE;
    const offset = Number.isFinite(offsetRaw) && offsetRaw > 0 ? offsetRaw : 0;

    const tickets = await db
      .select({
        id: ticketsTable.id,
        title: ticketsTable.title,
        description: ticketsTable.description,
        status: ticketsTable.status,
        priority: ticketsTable.priority,
        progress: ticketsTable.progress,
        departmentId: ticketsTable.departmentId,
        departmentName: departmentsTable.name,
        createdBy: ticketsTable.createdBy,
        assignedTo: ticketsTable.assignedTo,
        createdAt: ticketsTable.createdAt,
        updatedAt: ticketsTable.updatedAt,
        commentCount: sql<number>`count(${commentsTable.id})::int`.as("comment_count"),
      })
      .from(ticketsTable)
      .leftJoin(departmentsTable, eq(departmentsTable.id, ticketsTable.departmentId))
      .leftJoin(commentsTable, eq(commentsTable.ticketId, ticketsTable.id))
      .where(whereExpr)
      .groupBy(ticketsTable.id, departmentsTable.name)
      .orderBy(desc(ticketsTable.updatedAt), desc(ticketsTable.id))
      .limit(limit)
      .offset(offset);

    const [{ total }] = await db
      .select({ total: sql<number>`count(*)::int` })
      .from(ticketsTable)
      .where(whereExpr);

    // El cuerpo sigue siendo un arreglo (compatible con el panel y la app móvil);
    // el total de tickets que cumplen el filtro va en un encabezado.
    res.set("X-Total-Count", String(total));
    res.set("Access-Control-Expose-Headers", "X-Total-Count");
    res.json(tickets);
    return;
  } catch (err) {
    req.log.error({ err }, "Failed to get tickets");
    res.status(500).json({ error: "Internal server error" });
    return;
  }
});

router.post("/tickets", async (req, res) => {
  try {
    const user = req.authUser!;
    const b = req.body as Record<string, unknown>;

    const title = typeof b.title === "string" ? b.title.trim() : "";
    const description = typeof b.description === "string" ? b.description.trim() : "";
    const deptParsed = Number(b.departmentId);
    const priorityRaw = typeof b.priority === "string" ? b.priority.toLowerCase().trim() : "";
    const createdByBody = typeof b.createdBy === "string" ? b.createdBy.trim() : "";

    if (!title || !description) {
      res.status(400).json({ error: "Missing required fields" });
      return;
    }
    if (!Number.isFinite(deptParsed) || deptParsed <= 0) {
      res.status(400).json({ error: "departmentId inválido" });
      return;
    }
    if (!TICKET_PRIORITIES.includes(priorityRaw as TicketPriority)) {
      res.status(400).json({ error: "priority inválida" });
      return;
    }
    const priority = priorityRaw as TicketPriority;
    const departmentId = deptParsed;

    let author = user.name.trim();
    if (user.role === "admin" && createdByBody) {
      const raw = createdByBody;
      const [target] = await db
        .select()
        .from(usersTable)
        .where(sql`lower(trim(${usersTable.name})) = lower(trim(${raw}))`);
      author = target?.name ?? raw;
    }

    const [ticket] = await db
      .insert(ticketsTable)
      .values({
        title,
        description,
        priority,
        departmentId,
        createdBy: author,
        status: "open",
      })
      .returning();

    const [dept] = await db.select().from(departmentsTable).where(eq(departmentsTable.id, ticket.departmentId));
    res.status(201).json({ ...ticket, departmentName: dept?.name ?? null, commentCount: 0 });
    return;
  } catch (err) {
    req.log.error({ err }, "Failed to create ticket");
    res.status(500).json({ error: "Internal server error" });
    return;
  }
});

router.get("/tickets/:id", async (req, res) => {
  try {
    const user = req.authUser!;
    const id = parseInt(req.params.id);
    const [ticket] = await db
      .select({
        id: ticketsTable.id,
        title: ticketsTable.title,
        description: ticketsTable.description,
        status: ticketsTable.status,
        priority: ticketsTable.priority,
        progress: ticketsTable.progress,
        departmentId: ticketsTable.departmentId,
        departmentName: departmentsTable.name,
        createdBy: ticketsTable.createdBy,
        assignedTo: ticketsTable.assignedTo,
        createdAt: ticketsTable.createdAt,
        updatedAt: ticketsTable.updatedAt,
        commentCount: sql<number>`count(${commentsTable.id})::int`.as("comment_count"),
      })
      .from(ticketsTable)
      .leftJoin(departmentsTable, eq(departmentsTable.id, ticketsTable.departmentId))
      .leftJoin(commentsTable, eq(commentsTable.ticketId, ticketsTable.id))
      .where(eq(ticketsTable.id, id))
      .groupBy(ticketsTable.id, departmentsTable.name);

    if (!ticket) {
      res.status(404).json({ error: "Not found" });
      return;
    }
    if (!canAccessTicket(user, ticket)) {
      res.status(403).json({ error: "Acceso no autorizado" });
      return;
    }
    res.json(ticket);
    return;
  } catch (err) {
    req.log.error({ err }, "Failed to get ticket");
    res.status(500).json({ error: "Internal server error" });
    return;
  }
});

router.patch("/tickets/:id", async (req, res) => {
  try {
    const user = req.authUser!;
    const id = parseInt(req.params.id);
    const [existing] = await db
      .select({
        id: ticketsTable.id,
        departmentId: ticketsTable.departmentId,
        createdBy: ticketsTable.createdBy,
      })
      .from(ticketsTable)
      .where(eq(ticketsTable.id, id));

    if (!existing) {
      res.status(404).json({ error: "Not found" });
      return;
    }
    if (!canAccessTicket(user, existing)) {
      res.status(403).json({ error: "Acceso no autorizado" });
      return;
    }

    const { title, description, status, priority, assignedTo, progress } = req.body;

    const updateFields: Partial<
      Pick<Ticket, "title" | "description" | "status" | "priority" | "assignedTo" | "progress">
    > & { updatedAt: Date } = { updatedAt: new Date() };
    if (title !== undefined) updateFields.title = title;
    if (description !== undefined) updateFields.description = description;
    if (status !== undefined) updateFields.status = status;
    if (priority !== undefined) updateFields.priority = priority;
    if (assignedTo !== undefined) updateFields.assignedTo = assignedTo;
    if (progress !== undefined) updateFields.progress = Math.max(0, Math.min(100, Number(progress)));

    const [ticket] = await db
      .update(ticketsTable)
      .set(updateFields)
      .where(eq(ticketsTable.id, id))
      .returning();

    if (!ticket) {
      res.status(404).json({ error: "Not found" });
      return;
    }

    const [dept] = await db.select().from(departmentsTable).where(eq(departmentsTable.id, ticket.departmentId));
    const [{ count }] = await db
      .select({ count: sql<number>`count(*)::int` })
      .from(commentsTable)
      .where(eq(commentsTable.ticketId, id));

    res.json({ ...ticket, departmentName: dept?.name ?? null, commentCount: count });
    return;
  } catch (err) {
    req.log.error({ err }, "Failed to update ticket");
    res.status(500).json({ error: "Internal server error" });
    return;
  }
});

router.delete("/tickets/:id", async (req, res) => {
  try {
    const user = req.authUser!;
    if (user.role !== "admin") {
      res.status(403).json({ error: "Acceso no autorizado" });
      return;
    }
    const id = parseInt(req.params.id);
    await db.delete(commentsTable).where(eq(commentsTable.ticketId, id));
    await db.delete(ticketsTable).where(eq(ticketsTable.id, id));
    res.status(204).send();
    return;
  } catch (err) {
    req.log.error({ err }, "Failed to delete ticket");
    res.status(500).json({ error: "Internal server error" });
    return;
  }
});

export default router;
