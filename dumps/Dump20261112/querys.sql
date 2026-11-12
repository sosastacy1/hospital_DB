	USE hospital_db;
    
    -- 1. FATURAMENTO TOTAL DE CONSULTAS POR CONVÊNIO
SELECT
    pacientes.convenio,
    SUM(consultas.valor_consulta) AS faturamento_total
FROM pacientes
INNER JOIN consultas
    ON pacientes.id_paciente = consultas.id_paciente
WHERE pacientes.convenio LIKE '%Saúde%'
GROUP BY pacientes.convenio
ORDER BY faturamento_total DESC;

	-- 2. MÉDIA DO VALOR DE CONSULTA
SELECT
    medicos.especialidade,
    ROUND(AVG(consultas.valor_consulta), 2) AS media_valor_consulta
FROM consultas
INNER JOIN medicos ON consultas.id_medico = medicos.id_medico
WHERE medicos.especialidade LIKE '%Cardiologia%'
GROUP BY medicos.especialidade;

	-- 3. VALOR MÉDIO DAS DIÁRIAS POR TIPO DE QUARTO
SELECT
    quartos.tipo_quarto,
    ROUND(AVG(internacoes.valor_diaria), 2) AS media_diaria
FROM internacoes
INNER JOIN quartos 
	ON internacoes.id_quarto = quartos.id_quarto
WHERE quartos.tipo_quarto IN ('Apartamento', 'UTI')
GROUP BY quartos.tipo_quarto;

	-- 4. TOTAL DE CONSULTAS REALIZADAS POR MÉDICO
SELECT
    medicos.nome_medico AS medico,
    COUNT(consultas.id_consulta) AS total_consultas,
    SUM(consultas.valor_consulta) AS valor_total
FROM medicos
INNER JOIN consultas
    ON consultas.id_medico = medicos.id_medico
WHERE consultas.status_consulta IN ('Realizada', 'Finalizada')
GROUP BY medicos.id_medico, medicos.nome_medico
ORDER BY valor_total DESC;

	-- 5. SOMA DE DIÁRIAS POR PACIENTE COM SOBRENOME "SILVA"
SELECT
    pacientes.nome_paciente,
    SUM(internacoes.valor_diaria) AS total_diarias
FROM internacoes
INNER JOIN pacientes
    ON internacoes.id_paciente = pacientes.id_paciente
WHERE pacientes.nome_paciente LIKE '%Silva'
GROUP BY pacientes.id_paciente, pacientes.nome_paciente
ORDER BY total_diarias DESC;

	-- 6. CONTAGEM DE PRESCRIÇÕES POR STATUS DA CONSULTA
SELECT
    consultas.status_consulta AS status_consulta,
    COUNT(prescricoes.id_prescricao) AS total_prescricoes
FROM prescricoes
INNER JOIN consultas
    ON prescricoes.id_consulta = consultas.id_consulta
WHERE prescricoes.medicamento LIKE '%Dipirona%'
    OR prescricoes.medicamento LIKE '%Paracetamol%'
GROUP BY consultas.status_consulta
ORDER BY consultas.status_consulta;

	-- 7. MÉDIA DE VALOR DE CONSULTAS POR CONVÊNIO E ESPECIALIDADE
SELECT
    pacientes.convenio AS convenio,
    medicos.especialidade AS especialidade,
    COUNT(consultas.id_consulta) AS total_consultas,
    ROUND(AVG(consultas.valor_consulta), 2) AS valor_media
FROM consultas
INNER JOIN pacientes ON consultas.id_paciente = pacientes.id_paciente
INNER JOIN medicos ON consultas.id_medico = medicos.id_medico
WHERE pacientes.convenio LIKE '%Unimed%'
GROUP BY pacientes.convenio, medicos.especialidade
ORDER BY pacientes.convenio, valor_media DESC;

	-- 8. MÉDIA DE DIÁRIA DE INTERNAÇÃO POR CONVÊNIO EM QUARTOS DE UTI
SELECT
    pacientes.convenio AS convenio,
    COUNT(internacoes.id_internacao) AS total_internacoes,
    ROUND(AVG(internacoes.valor_diaria), 2) AS media_valor_diaria
FROM internacoes
INNER JOIN pacientes ON internacoes.id_paciente = pacientes.id_paciente
INNER JOIN quartos ON internacoes.id_quarto = quartos.id_quarto
WHERE quartos.tipo_quarto = 'UTI'
GROUP BY pacientes.convenio
ORDER BY media_valor_diaria DESC;

	-- 9. MEDICAMENTOS PRESCRITOS POR MÉDICO EM CONSULTAS REALIZADAS
SELECT
    medicos.nome_medico AS medico,
    COUNT(prescricoes.id_prescricao) AS total_medicamentos_prescritos
FROM medicos
INNER JOIN consultas ON medicos.id_medico = consultas.id_medico
INNER JOIN prescricoes ON consultas.id_consulta = prescricoes.id_consulta
WHERE consultas.status_consulta = 'Realizada'
GROUP BY medicos.id_medico, medicos.nome_medico
ORDER BY total_medicamentos_prescritos DESC;

	-- 10. VALOR TOTAL E MÉDIA DE CONSULTAS POR PACIENTE
SELECT
    pacientes.nome_paciente AS paciente,
    COUNT(consultas.id_consulta) AS total_consultas,
    SUM(consultas.valor_consulta) AS valor_total,
    ROUND(AVG(consultas.valor_consulta), 2) AS media_valor_consultas
FROM pacientes
INNER JOIN consultas ON pacientes.id_paciente = consultas.id_paciente
WHERE pacientes.nome_paciente LIKE 'M%'
GROUP BY pacientes.id_paciente, pacientes.nome_paciente
ORDER BY valor_total DESC;