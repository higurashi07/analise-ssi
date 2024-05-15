DELETE FROM public.transparencia WHERE cargos IS NULL OR numero_de_profissionais IS NULL;

-- Removendo estagiários
DELETE FROM public.transparencia WHERE cargos ILIKE '%est_giario%';

-- Criando e populando a coluna de atividade do cargo
ALTER TABLE public.transparencia ADD COLUMN atividade_cargo VARCHAR(255);

---- como os dados não são padronizados, a consulta deve ser abrangente em tipos de escrita ---
UPDATE public.transparencia
SET atividade_cargo = 
    CASE 
        WHEN cargos ILIKE '%Nutricionista%' OR cargos ILIKE '%Nutri__o%' OR cargos ILIKE '%Cozinh%' 
             OR cargos ILIKE '%Chef' OR cargos ILIKE '%Magarefe%' OR cargos ILIKE '%Maitre%'
             OR cargos ILIKE '%Confeit%' OR cargos ILIKE '%Copeiro%' OR cargos ILIKE '%Gar_om%'
             OR cargos ILIKE '%Lanch%' OR cargos ILIKE '%Merend%' THEN 'Nutricao'
        WHEN cargos ILIKE '%Sa_de bucal%' OR cargos ILIKE '%Dentista%' OR cargos ILIKE '%Odonto%' 
             THEN 'Saude Bucal'
        WHEN cargos ILIKE '%Fisioterapeuta%' OR cargos ILIKE '%Psic_log%' OR cargos ILIKE '%Radiologi%' 
             OR cargos ILIKE '%Enferm%' OR cargos ILIKE '%M_dic%'  THEN 'Atencao ampliada'
        WHEN cargos ILIKE '%Educ em sa_de%' OR cargos ILIKE '%sa_de%' THEN 'Educacao em Saude'
        ELSE ''
    END;

-- Selecionando o RH por atividade
SELECT * 
FROM transparencia
WHERE atividade_cargo <> ''
ORDER BY cargos, unidade;

-- Soma por categoria
SELECT INITCAP(cargos) AS cargos,  
       atividade_cargo, 
       unidade, 
       SUM(numero_de_profissionais) AS total_profissionais
FROM transparencia 
WHERE atividade_cargo <> ''
GROUP BY cargos, unidade, atividade_cargo
ORDER BY unidade;