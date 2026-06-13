import React, { useState } from "react";
import { ChevronLeft, Minus, Plus, Trash2, MapPin, Tag } from "lucide-react";
import { BottomNav } from "../BottomNav";

interface Props {
  onNavigate: (screen: string) => void;
}

export function CartScreen({ onNavigate }: Props) {
  const [items, setItems] = useState([
    { name: "Coq au Vin", price: 890, qty: 1, img: "https://images.unsplash.com/photo-1600891964092-4316c288032e?w=80&h=80&fit=crop&auto=format" },
    { name: "Soupe à l'oignon", price: 450, qty: 2, img: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=80&h=80&fit=crop&auto=format" },
    { name: "Crème Brûlée", price: 350, qty: 1, img: "https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc?w=80&h=80&fit=crop&auto=format" },
  ]);

  const adj = (i: number, d: number) => {
    setItems(prev => prev.map((item, idx) => idx === i ? { ...item, qty: Math.max(1, item.qty + d) } : item));
  };
  const remove = (i: number) => setItems(prev => prev.filter((_, idx) => idx !== i));

  const subtotal = items.reduce((s, i) => s + i.price * i.qty, 0);
  const delivery = 150;
  const total = subtotal + delivery;

  return (
    <div className="flex flex-col h-full bg-[#F5F5F5]">
      {/* Header */}
      <div className="bg-white pt-12 pb-4 px-5 flex items-center gap-3 shadow-sm">
        <button onClick={() => onNavigate("menu")} className="w-8 h-8 rounded-xl bg-gray-100 flex items-center justify-center">
          <ChevronLeft size={18} className="text-gray-700" />
        </button>
        <div className="flex-1">
          <h1 className="font-bold text-gray-800 text-base">Mon Panier</h1>
          <p className="text-xs text-gray-400">{items.length} article{items.length > 1 ? "s" : ""}</p>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-5 py-4 pb-20 space-y-3">
        {/* Items */}
        {items.map((item, i) => (
          <div key={i} className="bg-white rounded-2xl p-3 flex items-center gap-3 shadow-sm">
            <img src={item.img} alt={item.name} className="w-16 h-16 rounded-xl object-cover" />
            <div className="flex-1">
              <p className="font-semibold text-gray-800 text-sm">{item.name}</p>
              <p className="text-[#E53935] font-bold text-sm mt-0.5">{item.price} DA</p>
            </div>
            <div className="flex flex-col items-end gap-2">
              <button onClick={() => remove(i)} className="text-gray-300 hover:text-red-400">
                <Trash2 size={14} />
              </button>
              <div className="flex items-center gap-2">
                <button onClick={() => adj(i, -1)} className="w-6 h-6 rounded-lg bg-gray-100 flex items-center justify-center">
                  <Minus size={12} className="text-gray-600" />
                </button>
                <span className="text-sm font-semibold text-gray-800 w-4 text-center">{item.qty}</span>
                <button onClick={() => adj(i, 1)} className="w-6 h-6 rounded-lg bg-[#E53935] flex items-center justify-center">
                  <Plus size={12} className="text-white" />
                </button>
              </div>
            </div>
          </div>
        ))}

        {/* Delivery address */}
        <div className="bg-white rounded-2xl p-4 shadow-sm">
          <div className="flex items-center gap-2 mb-1">
            <MapPin size={15} className="text-[#E53935]" />
            <p className="font-semibold text-gray-800 text-sm">Adresse de livraison</p>
          </div>
          <p className="text-xs text-gray-500 ml-5">12 Rue Didouche Mourad, Alger Centre</p>
          <button className="ml-5 mt-1 text-xs text-[#E53935] font-medium">Modifier →</button>
        </div>

        {/* Promo code */}
        <div className="bg-white rounded-2xl p-3 flex items-center gap-3 shadow-sm">
          <Tag size={16} className="text-gray-400" />
          <input placeholder="Code promo" className="flex-1 text-sm text-gray-700 outline-none bg-transparent placeholder:text-gray-400" />
          <button className="px-3 py-1.5 rounded-lg bg-[#E53935] text-white text-xs font-semibold">Appliquer</button>
        </div>

        {/* Summary */}
        <div className="bg-white rounded-2xl p-4 shadow-sm space-y-2">
          <p className="font-semibold text-gray-800 text-sm mb-3">Récapitulatif</p>
          <div className="flex justify-between text-xs text-gray-500">
            <span>Sous-total</span>
            <span className="font-medium text-gray-700">{subtotal.toLocaleString()} DA</span>
          </div>
          <div className="flex justify-between text-xs text-gray-500">
            <span>Livraison</span>
            <span className="font-medium text-gray-700">{delivery} DA</span>
          </div>
          <div className="flex justify-between text-xs text-gray-500">
            <span>Remise</span>
            <span className="font-medium text-green-500">- 0 DA</span>
          </div>
          <div className="border-t border-gray-100 pt-2 flex justify-between">
            <span className="font-bold text-gray-800 text-sm">Total</span>
            <span className="font-bold text-[#E53935] text-sm">{total.toLocaleString()} DA</span>
          </div>
        </div>
      </div>

      {/* Checkout CTA */}
      <div className="absolute bottom-0 left-0 right-0 bg-white border-t border-gray-100 px-5 py-4 pb-6">
        <button
          onClick={() => onNavigate("tracking")}
          className="w-full py-3.5 rounded-xl bg-[#E53935] text-white font-semibold text-sm shadow-lg shadow-red-200"
        >
          Passer la commande · {total.toLocaleString()} DA
        </button>
      </div>

      <BottomNav active="cart" onNavigate={onNavigate} />
    </div>
  );
}
