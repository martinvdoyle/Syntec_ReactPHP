import { Link } from "react-router-dom";

export default function MobileMenu({ isOpen, onClose, items = [] }) {
  if (!isOpen) {
    return null;
  }

  return (
    <div className="lg:hidden border-t border-slate-200 bg-white">
      <div className="mx-auto max-w-7xl px-4 py-3">
        <ul className="space-y-2">
          {items.map((item) => (
            <li key={item.id}>
              <Link
                className="block rounded-md px-3 py-2 text-sm text-slate-700 hover:bg-slate-100"
                to={item.route || item.url || "#"}
                onClick={onClose}
              >
                {item.title}
              </Link>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
