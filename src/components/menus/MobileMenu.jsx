import { useState } from "react";
import { Link } from "react-router-dom";

function MobileNode({ item, onClose, level = 0 }) {
  const [open, setOpen] = useState(false);
  const hasChildren = Array.isArray(item.children) && item.children.length > 0;

  return (
    <li>
      <div className="flex items-center gap-2">
        <Link
          className="block flex-1 rounded-md px-3 py-2 text-sm text-slate-700 hover:bg-slate-100"
          style={{ paddingLeft: `${12 + level * 14}px` }}
          to={item.route || item.url || "#"}
          onClick={onClose}
        >
          {item.title}
        </Link>
        {hasChildren ? (
          <button type="button" className="px-2 text-slate-500" onClick={() => setOpen((v) => !v)}>
            {open ? "−" : "+"}
          </button>
        ) : null}
      </div>
      {hasChildren && open ? (
        <ul className="space-y-1">
          {item.children.map((child) => (
            <MobileNode key={child.id} item={child} onClose={onClose} level={level + 1} />
          ))}
        </ul>
      ) : null}
    </li>
  );
}

export default function MobileMenu({ isOpen, onClose, items = [] }) {
  if (!isOpen) return null;

  return (
    <div className="border-t border-slate-200 bg-white lg:hidden">
      <div className="mx-auto max-w-7xl px-4 py-3">
        <ul className="space-y-1">
          {items.map((item) => (
            <MobileNode key={item.id} item={item} onClose={onClose} />
          ))}
        </ul>
      </div>
    </div>
  );
}
