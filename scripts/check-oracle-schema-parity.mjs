import fs from "node:fs";
import path from "node:path";

const ROOT = process.cwd();
const ORACLE_DIR = path.join(ROOT, "Oracle_Exports");
const MYSQL_DIR = path.join(ROOT, "database", "mysql");

const TABLE_MAP = {
  syntec_suppliers: { oracle: "SUPPLIERS.sql", mysql: "002_syntec_suppliers.sql" },
  syntec_products: { oracle: "PRODUCTS.sql", mysql: "005_syntec_products.sql" },
  syntec_discipline: { oracle: "DISCIPLINE.sql", mysql: "006_syntec_discipline.sql" },
  syntec_product_group: { oracle: "PRODUCT_GROUP.sql", mysql: "007_syntec_product_group.sql" },
  syntec_product_type: { oracle: "PRODUCT_TYPE.sql", mysql: "008_syntec_product_type.sql" },
  syntec_divisions: { oracle: "SYNTEC_DIVISIONS.sql", mysql: "009_syntec_divisions.sql" },
  syntec_job_titles: { oracle: "SYNTEC_JOB_TITLES.sql", mysql: "010_syntec_job_titles.sql" },
  syntec_message_enquiry_type: { oracle: "SYNTEC_MESSAGE_ENQUIRY_TYPE.sql", mysql: "011_syntec_message_enquiry_type.sql" },
  syntec_message_types: { oracle: "SYNTEC_MESSAGE_TYPES.sql", mysql: "012_syntec_message_types.sql" },
  syntec_sources: { oracle: "SYNTEC_SOURCES.sql", mysql: "013_syntec_sources.sql" },
  syntec_users: { oracle: "SYNTEC_USERS.sql", mysql: "014_syntec_users.sql" },
  syntec_messages: { oracle: "SYNTEC_MESSAGES.sql", mysql: "015_syntec_messages.sql" },
};

function read(file) {
  return fs.readFileSync(file, "utf8");
}

function parseOracleColumns(sql) {
  const m = sql.match(/CREATE TABLE[\s\S]*?\(([\s\S]*?)\)\s*(?:SEGMENT|PCTFREE|TABLESPACE|;)/i);
  if (!m) return [];
  const out = [];
  for (const line of m[1].split("\n")) {
    const s = line.trim().replace(/,$/, "");
    const c = s.match(/^"([^"]+)"\s+/);
    if (c) out.push(c[1].toLowerCase());
  }
  return out;
}

function parseMySqlColumns(sql) {
  const m = sql.match(/CREATE TABLE[\s\S]*?\(([\s\S]*?)\)\s*ENGINE=/i);
  if (!m) return [];
  const out = [];
  for (const line of m[1].split("\n")) {
    const s = line.trim().replace(/,$/, "");
    if (!s) continue;
    if (/^(PRIMARY|UNIQUE|KEY|CONSTRAINT)\b/i.test(s)) continue;
    const c = s.match(/^`?([a-zA-Z0-9_]+)`?\s+/);
    if (c) out.push(c[1].toLowerCase());
  }
  return out;
}

let hasMismatch = false;
for (const [table, files] of Object.entries(TABLE_MAP)) {
  const oraclePath = path.join(ORACLE_DIR, files.oracle);
  const mysqlPath = path.join(MYSQL_DIR, files.mysql);

  if (!fs.existsSync(oraclePath) || !fs.existsSync(mysqlPath)) {
    hasMismatch = true;
    console.log(`\n[ERROR] ${table}`);
    console.log(`  Missing file(s): oracle=${fs.existsSync(oraclePath)} mysql=${fs.existsSync(mysqlPath)}`);
    continue;
  }

  const oracleCols = parseOracleColumns(read(oraclePath));
  const mysqlCols = parseMySqlColumns(read(mysqlPath));

  const extra = mysqlCols.filter((c) => !oracleCols.includes(c));
  const missing = oracleCols.filter((c) => !mysqlCols.includes(c));

  if (extra.length || missing.length) {
    hasMismatch = true;
    console.log(`\n[MISMATCH] ${table}`);
    console.log(`  Extra in MySQL (${extra.length}): ${extra.join(", ") || "-"}`);
    console.log(`  Missing in MySQL (${missing.length}): ${missing.join(", ") || "-"}`);
  } else {
    console.log(`\n[OK] ${table} (exact column parity)`);
  }
}

if (hasMismatch) {
  console.log("\nSchema parity check FAILED.");
  process.exit(1);
}

console.log("\nSchema parity check PASSED.");

