# Plan de pruebas - OneData Financial Flow Map

## Funcionales

1. Ejecutar análisis en una empresa sin contratos.
2. Ejecutar análisis con una empresa y un contrato vigente.
3. Ejecutar análisis con varias empresas y contratos simultáneos.
4. Validar contrato sin fecha final.
5. Validar contrato vencido con exclusión por defecto.
6. Validar contrato futuro con exclusión por defecto.
7. Validar contrato cancelado con exclusión por defecto.
8. Validar activo sin valor de mercado.
9. Validar activo sin precio de compra.
10. Validar activo con solo valor catastral.
11. Validar renta mensual.
12. Validar renta trimestral.
13. Validar renta anual.
14. Validar contrato con revisión IPC disponible.
15. Validar contrato con renta cero.
16. Validar contrato con importe pendiente.
17. Validar cliente bloqueado cuando exista indicador real.
18. Validar contrato próximo a vencer.
19. Validar contrato sin fianza ni garantía.
20. Validar yield inferior al objetivo.
21. Crear snapshot.
22. Comparar snapshots consecutivos.
23. Eliminar snapshot.
24. Exportar a Excel.
25. Validar usuario sin permisos en una empresa.
26. Validar error de datos en un contrato.
27. Ejecutar análisis con volumen alto.
28. Validar totales ponderados.
29. Abrir lista de contratos en empresa destino.
30. Abrir lista de activos en empresa destino.

## Técnicas

1. Revisar que el buffer se limpia por usuario antes de cada ejecución.
2. Revisar que la página principal filtra por `User ID`.
3. Revisar que los snapshots conservan valores calculados sin recálculo posterior.
4. Revisar que la comparación no altera snapshots origen.
5. Revisar que no se usan `COMMIT` dentro de los bucles de análisis.
6. Revisar que las divisiones por cero devuelven `0`.
7. Revisar que fechas vacías no provocan error.
8. Revisar que importes negativos no bloquean la ejecución.
9. Revisar que `ChangeCompany` no cambia la empresa activa.
10. Revisar que el adaptador concentra todos los supuestos de integración real.
