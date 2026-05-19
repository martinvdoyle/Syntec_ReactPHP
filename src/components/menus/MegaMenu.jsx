import { Link } from "react-router-dom";

export default function MegaMenu({ items = [] }) {
  if (!items.length) {
    return null;
  }

  return (
    <div className="hidden lg:block border-t border-slate-200 bg-white/95">
      <div className="mx-auto max-w-7xl px-4 py-2">
        <ul className="flex flex-wrap gap-4 text-sm text-slate-700">
          {items.map((item) => (
            <li key={item.id}>
              <Link className="hover:text-[var(--syntec-blue)]" to={item.route || item.url || "#"}>
                {item.title}
              </Link>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
