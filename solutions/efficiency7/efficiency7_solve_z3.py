# pip install z3-solver
#
# Note that the package name is NOT z3.
import z3

solver = z3.Solver()
n = z3.BitVec("n", 40)

v1 = z3.Bool("v1")
v2 = z3.Bool("v2")
v3 = z3.Bool("v3")
v4 = z3.Bool("v4")
v5 = z3.Bool("v5")
v6 = z3.Bool("v6")
v7 = z3.Bool("v7")
v8 = z3.Bool("v8")
v9 = z3.Bool("v9")
v10 = z3.Bool("v10")
v11 = z3.Bool("v11")
v12 = z3.Bool("v12")
v13 = z3.Bool("v13")
v14 = z3.Bool("v14")
v15 = z3.Bool("v15")
v16 = z3.Bool("v16")
v17 = z3.Bool("v17")
v18 = z3.Bool("v18")
v19 = z3.Bool("v19")
v20 = z3.Bool("v20")
v21 = z3.Bool("v21")
v22 = z3.Bool("v22")
v23 = z3.Bool("v23")
v24 = z3.Bool("v24")
v25 = z3.Bool("v25")
v26 = z3.Bool("v26")
v27 = z3.Bool("v27")
v28 = z3.Bool("v28")
v29 = z3.Bool("v29")
v30 = z3.Bool("v30")
v31 = z3.Bool("v31")
v32 = z3.Bool("v32")
v33 = z3.Bool("v33")
v34 = z3.Bool("v34")
v35 = z3.Bool("v35")
v36 = z3.Bool("v36")
v37 = z3.Bool("v37")
v38 = z3.Bool("v38")
v39 = z3.Bool("v39")
v40 = z3.Bool("v40")

cond = z3.And(z3.Or(z3.Not(v18), z3.Not(v15)), z3.Or(z3.Not(v14), z3.Not(v9)), z3.Or(z3.Not(v19), v37, v12), z3.Not(v39), z3.Or(z3.Not(v20), v18), z3.Or(z3.Not(v8), v16, z3.Not(v24)), z3.Or(z3.Not(v29), z3.Not(v39)), z3.Or(z3.Not(v2), v19), v15, z3.Or(z3.Not(v37), v19, z3.Not(v6)), z3.Or(v25, z3.Not(v23)), z3.Or(z3.Not(v17), v40, v21), z3.Or(z3.Not(v23), v35, v24), z3.Or(z3.Not(v30), z3.Not(v28)), v15, z3.Or(z3.Not(v37), v19, v6), z3.Or(z3.Not(v3), z3.Not(v11)), z3.Or(z3.Not(v35), z3.Not(v3)), z3.Or(z3.Not(v29), v39, v22), z3.Or(z3.Not(v27), z3.Not(v10)), z3.Or(v28, z3.Not(v8)), z3.Or(z3.Not(v4), v39), z3.Or(v10, v26), z3.Or(v22, v14, v15), z3.Not(v13), z3.Or(v36, v28, z3.Not(v35)), z3.Or(z3.Not(v8), v16, v24), z3.Or(z3.Not(v7), v3, z3.Not(v40)), z3.Or(v22, v14, v15), z3.Not(v13), z3.Or(z3.Not(v8), v16, v24), z3.Or(z3.Not(v19), v37, v12), z3.Or(v10, z3.Not(v26)), z3.Or(z3.Not(v20), z3.Not(v18)), z3.Or(z3.Not(v8), z3.Not(v16)), z3.Or(z3.Not(v3), v11, z3.Not(v23)), z3.Or(z3.Not(v16), v37), z3.Or(z3.Not(v38), z3.Not(v11)), z3.Or(z3.Not(v31), v13, v14), z3.Or(z3.Not(v33), v19), z3.Or(z3.Not(v14), v9, z3.Not(v29)), z3.Or(v6, v16), z3.Or(v36, v28, v35), z3.Or(z3.Not(v19), z3.Not(v37)), z3.Or(z3.Not(v5), v6), z3.Or(v10, v26), z3.Or(z3.Not(v3), v11, v23), z3.Or(v26, v37, z3.Not(v16)), z3.Or(v22, v14, z3.Not(v15)), z3.Or(v25, v23, v38), z3.Or(v36, z3.Not(v28)), z3.Or(z3.Not(v35), v3), z3.Or(z3.Not(v34), v35, z3.Not(v37)), z3.Or(z3.Not(v5), z3.Not(v6)), z3.Or(z3.Not(v33), z3.Not(v19)), z3.Or(z3.Not(v17), v40, v21), z3.Or(z3.Not(v30), v28, v4), z3.Or(z3.Not(v34), v35, v37), z3.Or(v28, v8, v29), z3.Not(v21), z3.Or(z3.Not(v18), v15, v39), v40, z3.Or(z3.Not(v3), v11, v23), z3.Or(z3.Not(v17), z3.Not(v40)), z3.Or(z3.Not(v35), v3), z3.Or(z3.Not(v33), v19), z3.Or(v25, v23, z3.Not(v38)), z3.Or(z3.Not(v27), v10), z3.Or(v36, v28, v35), z3.Or(z3.Not(v7), v3, v40), z3.Or(z3.Not(v11), v35), z3.Or(v6, v16), z3.Or(z3.Not(v30), v28, v4), z3.Or(z3.Not(v11), z3.Not(v35)), z3.Or(z3.Not(v32), v19), z3.Or(z3.Not(v37), z3.Not(v19)), z3.Or(v26, z3.Not(v37)), z3.Or(z3.Not(v30), v28, z3.Not(v4)), z3.Not(v21), z3.Or(z3.Not(v20), v18), z3.Or(z3.Not(v9), v31), z3.Or(v28, v8, v29), z3.Or(z3.Not(v31), v13, z3.Not(v14)), z3.Or(z3.Not(v24), v32, v35), z3.Or(v12, v16), z3.Or(z3.Not(v29), v39, v22), z3.Or(z3.Not(v14), v9, v29), z3.Not(v39), z3.Or(z3.Not(v4), z3.Not(v39)), z3.Or(z3.Not(v37), v19, v6), z3.Or(z3.Not(v23), z3.Not(v35)), z3.Or(z3.Not(v29), v39, z3.Not(v22)), z3.Or(z3.Not(v5), v6), v40, z3.Or(v25, v23, v38), z3.Or(z3.Not(v2), v19), z3.Or(v12, v16), z3.Or(z3.Not(v23), v35, v24), z3.Or(z3.Not(v31), z3.Not(v13)), z3.Or(z3.Not(v34), z3.Not(v35)), z3.Or(z3.Not(v32), v19), z3.Or(z3.Not(v24), v32, v35), z3.Or(v26, v37, v16), z3.Or(z3.Not(v38), v11), z3.Or(z3.Not(v16), v37), z3.Or(z3.Not(v7), v3, v40), z3.Or(z3.Not(v4), v39), z3.Or(z3.Not(v7), z3.Not(v3)), z3.Or(z3.Not(v24), v32, z3.Not(v35)), z3.Or(z3.Not(v34), v35, v37), z3.Or(z3.Not(v11), v35), v1, z3.Or(z3.Not(v27), v10), z3.Or(z3.Not(v23), v35, z3.Not(v24)), z3.Or(z3.Not(v18), v15, z3.Not(v39)), z3.Or(z3.Not(v19), v37, z3.Not(v12)), z3.Or(v26, v37, v16), z3.Or(v6, z3.Not(v16)), z3.Or(z3.Not(v17), v40, z3.Not(v21)), z3.Or(z3.Not(v9), z3.Not(v31)), z3.Or(z3.Not(v32), z3.Not(v19)), z3.Or(z3.Not(v38), v11), z3.Or(z3.Not(v9), v31), z3.Or(z3.Not(v14), v9, v29), z3.Or(z3.Not(v18), v15, v39), z3.Or(v12, z3.Not(v16)), z3.Or(z3.Not(v16), z3.Not(v37)), z3.Or(v22, z3.Not(v14)), z3.Or(v28, v8, z3.Not(v29)), v1, z3.Or(z3.Not(v24), z3.Not(v32)), z3.Or(z3.Not(v2), z3.Not(v19)), z3.Or(z3.Not(v31), v13, v14))

solver.add(cond)
solver.check()
m = solver.model()

bits = [m.evaluate(v) for v in [v1 , v2 , v3 , v4 , v5 , v6 , v7 , v8 , v9 , v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40]]
print(sum((1 << i) if b else 0 for i, b in enumerate(bits)))
