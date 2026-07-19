# Interni Roadmap — Diplomski rad
## Дизајн и имплементација интегрисане платформе за извођење Red и Blue Team вежби у академском окружењу

> Ovo je naš radni dokument, ne ide mentoru. Služi da znamo tačno šta radimo, kojim redom, i da ne lutamo.

---

## 0. Polazna tačka (već postoji)

Repo: `ProjekatKriptografija` (postaje osnova, proširujemo ga)
- Vagrant + VirtualBox, 2 VM-a (Attacker Debian 12, Target Ubuntu 22.04)
- Ansible playbook-ovi: setup-attacker.yml, setup-target.yml
- 2 attack scenarija: SSH bruteforce, FTP bruteforce
- Logovanje u /var/log/redteam/

**Odluka:** Vagrant se gasi, prelazimo na Terraform + libvirt/KVM. Ansible playbook-ove za attacker/target refaktorišemo u role, logiku napada zadržavamo (samo se menja provisioning ispod).

---

## 1. Finalna arhitektura

```
Terraform (libvirt provider)
   → izolovana libvirt mreža (NAT/isolated, bez interneta ka target/attacker segmentu)
   → Attacker VM (cloud-init, Debian/Kali cloud image)
   → Target VM (cloud-init, Ubuntu cloud image, ranjive usluge)
   → Blue Team VM (Wazuh manager + dashboard)
   → generiše ansible inventory (output iz terraform-a, npr. preko local_file resursa)

Ansible
   → role: attacker-setup (alati: nmap, hydra, john, masscan)
   → role: target-setup (ranjive usluge, slabe lozinke)
   → role: blueteam-setup (Wazuh manager instalacija, Wazuh agent na target VM)
   → playbook-ovi za scenarije (attack-ssh-bruteforce.yml, attack-ftp-bruteforce.yml, + novi)

Orkestracioni sloj (FastAPI backend)
   → pokreće terraform apply/destroy
   → pokreće ansible-playbook za setup i za scenario
   → čita Wazuh API za alerts/detekcije nakon scenarija
   → računa metrike (vreme do detekcije, broj detektovanih koraka napada)

Web Dashboard (frontend)
   → izbor scenarija
   → dugme Start/Stop vežbe
   → prikaz statusa uživo (log tail ili polling)
   → izveštaj na kraju: šta je Red uradio, šta je Blue detektovao, gde su promašaji
```

---

## 2. Struktura repozitorijuma (ciljna)

```
terraform/
  modules/
    network/
    attacker-vm/
    target-vm/
    blueteam-vm/
  environments/
    dev/
      main.tf
      variables.tf
      outputs.tf        # generiše ansible/inventory/hosts.ini

ansible/
  roles/
    attacker-setup/
    target-setup/
    blueteam-setup/
  playbooks/
    site.yml                      # provisioning svih mašina
    scenario-ssh-bruteforce.yml
    scenario-ftp-bruteforce.yml
  inventory/
    hosts.ini            # generisan, nije ručno pisan

platform/
  backend/               # FastAPI
    app/
      main.py
      terraform_runner.py
      ansible_runner.py
      wazuh_client.py
      scenarios.py
  frontend/               # web dashboard (React ili plain HTML/JS - odlučićemo kad stignemo)

docs/
  architecture.md
  diagrams/

README.md
```

---

## 3. Faze rada (redosled implementacije)

**Faza 1 — Terraform osnova (libvirt)**
- [ ] Modul za izolovanu mrežu
- [ ] Modul za VM (parametrizovan: ime, IP, image, resursi) — koristi se 3x (attacker/target/blueteam)
- [ ] cloud-init konfiguracija (SSH ključ, hostname, mrežni podaci)
- [ ] Output: automatski generisan Ansible inventory fajl
- [ ] Test: `terraform apply` diže 3 VM-a, mogu da im se `ssh`-uje

**Faza 2 — Ansible refaktoring**
- [ ] Prebaciti postojeće playbook-ove u role strukturu
- [ ] Dodati blueteam-setup rolu (Wazuh manager)
- [ ] Dodati Wazuh agent instalaciju na target-setup rolu
- [ ] Test: nakon provisioning-a, Wazuh dashboard je dostupan i vidi agenta

**Faza 3 — Scenariji + detekcija**
- [ ] Pokrenuti postojeće SSH/FTP bruteforce scenarije na novoj infrastrukturi
- [ ] Proveriti da Wazuh hvata pokušaje (default ruleset ili custom rules ako treba)
- [ ] Po potrebi dodati custom Wazuh detection rules za ove scenarije

**Faza 4 — Orkestracioni sloj (backend)**
- [ ] FastAPI endpoint: start scenario (triggeruje terraform + ansible + attack playbook)
- [ ] FastAPI endpoint: status (da li je infrastruktura gore, da li je napad u toku)
- [ ] FastAPI endpoint: report (povuci Wazuh alerts, sračunaj metrike)
- [ ] FastAPI endpoint: stop/destroy

**Faza 5 — Dashboard (frontend)**
- [ ] Lista scenarija sa opisom (edukativni deo)
- [ ] Start/Stop dugme + status prikaz
- [ ] Prikaz izveštaja posle vežbe (tabela: korak napada → detektovano/nije, vreme)

**Faza 6 — Evaluacija i pisanje**
- [ ] Testirati ceo tok end-to-end nekoliko puta
- [ ] Dokumentovati arhitekturu (dijagrami za rad)
- [ ] Pisanje diplomskog teksta paralelno sa gornjim fazama (ne na kraju!)

---

## 4. Otvorene odluke za kasnije (ne blokiraju start)

- Frontend: React vs. plain HTML/JS + htmx (odlučiti u Fazi 5)
- Da li dodati Suricata za mrežni IDS kao prošireno poglavlje
- Broj i tip scenarija van SSH/FTP bruteforce (npr. web app napad, privilege escalation) — dobro za "diskusiju" i "buduci rad" u radu, ali nije nužno za MVP

---

## 5. Sledeći konkretan korak

Kreni od **Faze 1**: Terraform modul za libvirt mrežu + parametrizovani VM modul. To je fundacija na kojoj sve ostalo stoji.
