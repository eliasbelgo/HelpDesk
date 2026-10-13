import rateLimit from "express-rate-limit";

const WINDOW_MS = 15 * 60 * 1000; // 15 minutos
const tooMany = { error: "Demasiados intentos fallidos. Intenta de nuevo en unos minutos." };

/** Máx. 5 intentos fallidos por cuenta (correo) cada 15 min. */
export const loginLimiterPorCuenta = rateLimit({
  windowMs: WINDOW_MS,
  limit: 5,
  skipSuccessfulRequests: true, // los inicios de sesión correctos no cuentan
  standardHeaders: "draft-7",
  legacyHeaders: false,
  keyGenerator: (req) => String(req.body?.email ?? "").trim().toLowerCase() || "sin-correo",
  message: tooMany,
});

/** Máx. 20 intentos fallidos por IP cada 15 min (frena a quien prueba muchas cuentas). */
export const loginLimiterPorIp = rateLimit({
  windowMs: WINDOW_MS,
  limit: 20,
  skipSuccessfulRequests: true,
  standardHeaders: "draft-7",
  legacyHeaders: false,
  message: tooMany,
});
