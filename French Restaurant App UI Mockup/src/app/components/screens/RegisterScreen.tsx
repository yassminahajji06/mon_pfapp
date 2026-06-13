import React, { useState } from "react";
import { ChevronLeft, User, Mail, Lock, Phone } from "lucide-react";

interface Props {
  onNavigate: (screen: string) => void;
}

export function RegisterScreen({ onNavigate }: Props) {
  const [role, setRole] = useState<"client" | "livreur">("client");

  const fields = [
    { icon: User, label: "Nom complet", placeholder: "Yassmine Hajji", type: "text" },
    { icon: Mail, label: "Adresse email", placeholder: "yassmine@email.com", type: "email" },
    { icon: Phone, label: "Téléphone", placeholder: "+213 6 00 00 00 00", type: "tel" },
    { icon: Lock, label: "Mot de passe", placeholder: "••••••••", type: "password" },
  ];

  return (
    <div className="flex flex-col h-full bg-white">
      {/* Top bar */}
      <div className="bg-[#E53935] pt-14 pb-10 px-5 relative">
        <button onClick={() => onNavigate("login")} className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center mb-4">
          <ChevronLeft size={18} className="text-white" />
        </button>
        <h1 className="text-white text-xl font-bold" style={{ fontFamily: "var(--font-display)" }}>Créer un compte</h1>
        <p className="text-red-200 text-xs mt-0.5">Rejoignez Mon PF App</p>
        <div className="absolute bottom-0 left-0 right-0 h-6 bg-white rounded-t-3xl" />
      </div>

      <div className="flex-1 px-6 pt-4 pb-6 overflow-y-auto">
        {/* Role selector */}
        <div className="flex gap-2 mb-5 p-1 bg-gray-100 rounded-xl">
          {(["client", "livreur"] as const).map(r => (
            <button
              key={r}
              onClick={() => setRole(r)}
              className={`flex-1 py-2 rounded-lg text-xs font-semibold transition-all ${
                role === r ? "bg-[#E53935] text-white shadow" : "text-gray-500"
              }`}
            >
              {r === "client" ? "Client" : "Livreur"}
            </button>
          ))}
        </div>

        <div className="space-y-4">
          {fields.map(({ icon: Icon, label, placeholder, type }) => (
            <div key={label}>
              <label className="text-xs font-semibold text-gray-600 uppercase tracking-wide">{label}</label>
              <div className="relative mt-1">
                <Icon size={15} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
                <input
                  type={type}
                  placeholder={placeholder}
                  className="w-full pl-10 pr-4 py-3 rounded-xl bg-gray-100 text-sm text-gray-800 outline-none border border-transparent focus:border-[#E53935] transition-colors placeholder:text-gray-400"
                />
              </div>
            </div>
          ))}

          {role === "livreur" && (
            <div>
              <label className="text-xs font-semibold text-gray-600 uppercase tracking-wide">Numéro de véhicule</label>
              <input
                placeholder="Ex: 12345-234-16"
                className="mt-1 w-full px-4 py-3 rounded-xl bg-gray-100 text-sm text-gray-800 outline-none border border-transparent focus:border-[#E53935] transition-colors placeholder:text-gray-400"
              />
            </div>
          )}
        </div>

        <div className="flex items-start gap-2 mt-5">
          <div className="w-4 h-4 mt-0.5 rounded border-2 border-[#E53935] bg-[#E53935] flex items-center justify-center flex-shrink-0">
            <div className="w-1.5 h-1.5 bg-white rounded-sm" />
          </div>
          <p className="text-xs text-gray-500">
            J'accepte les <span className="text-[#E53935]">conditions d'utilisation</span> et la{" "}
            <span className="text-[#E53935]">politique de confidentialité</span> de Mon PF App.
          </p>
        </div>

        <button
          onClick={() => onNavigate("home")}
          className="mt-6 w-full py-3.5 rounded-xl bg-[#E53935] text-white font-semibold shadow-lg shadow-red-200"
        >
          Créer mon compte
        </button>

        <p className="text-center text-xs text-gray-500 mt-4">
          Déjà inscrit ?{" "}
          <span className="text-[#E53935] font-semibold cursor-pointer" onClick={() => onNavigate("login")}>
            Se connecter
          </span>
        </p>
      </div>
    </div>
  );
}
