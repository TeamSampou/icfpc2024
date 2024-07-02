# Install [LKH-3](http://webhotel4.ruc.dk/~keld/research/LKH-3/)
# This script uses "./LKH-3.0.10/LKH".

import argparse
import math
import subprocess


def reorder(points):
    par_filename = "spaceship_tsp.tmp.par"
    tsp_filename = "spaceship_tsp.tmp.tsp"
    out_filename = "spaceship_tsp.tmp.out"

    nodes = [(0, 0)] + points + [None, None]
    dim = len(nodes)
    start_node_id = 0  # 始点
    sink_node_id = dim - 2  # 終点
    dummy_node_id = dim - 1  # 終点と始点を繋いでサイクルにするためのダミーのノード

    def dist(i, j):
        # ダミーのノードは始点と終点にはコスト0で繋がっているが他には繋がっていない
        if i == dummy_node_id:
            if j == start_node_id or j == sink_node_id:
                return 0
            else:
                return None
        if j == dummy_node_id:
            if i == start_node_id or i == sink_node_id:
                return 0
            else:
                return None
        # 終点は始点とダミー以外の全てのノードにコスト0で繋がっている
        if i == sink_node_id:
            if j == start_node_id:
                return None
            else:
                return 0
        if j == sink_node_id:
            if i == start_node_id:
                return None
            else:
                return 0

        p1 = nodes[i]
        p2 = nodes[j]
        return math.sqrt((p1[0] - p2[0]) ** 2 + (p1[1] - p2[1]) ** 2)

    edge_weights = [[dist(i, j) for j in range(i)] for i in range(len(nodes))]

    precision = 100
    int_max = 2**31

    # LKH は重みは整数である必要があり、
    # また w <= <= int_max // 2 // precision を満たす必要があるので、
    # 適当にスケーリング。
    #
    # 後述の inf と他の値に差が出るように 10 倍だけ余裕を持っておく
    max_w = max(w for ws in edge_weights for w in ws if w is not None)
    s = 1
    if round(10 * s * max_w) <= int_max // 2 // precision // 10:
        while round(10 * s * max_w) <= int_max // 2 // precision // 10:
            s *= 10
    else:
        while round(10 * s * max_w) > int_max // 2 // precision // 10:
            s /= 10
    edge_weights = [
        [None if w is None else round(s * w) for w in ws] for ws in edge_weights
    ]
    for ws in edge_weights:
        for w in ws:
            if w is not None:
                assert w <= int_max // 2 // precision // 10

    # EDGE_DATA_FORMAT を指定するとうまくいかないので、
    # その代わりにエッジがない場所には大きな値を入れておく。
    inf = int_max // 2 // precision

    with open(tsp_filename, "w") as f:
        print("NAME: hoge", file=f)
        print("TYPE: TSP", file=f)
        print(f"DIMENSION: {dim}", file=f)
        print(f"EDGE_WEIGHT_TYPE: EXPLICIT", file=f)
        print(f"EDGE_WEIGHT_FORMAT: LOWER_ROW", file=f)
        # print("EDGE_DATA_FORMAT: ADJ_LIST", file=f)
        # print("EDGE_DATA_SECTION:", file=f)
        # for i, ws in enumerate(edge_weights):
        #     print(' '.join(map(str, [i+1] + [j+1 for (j, w) in enumerate(ws) if w is not None] + [-1])), file=f)
        # print(f"-1", file=f)
        print(f"EDGE_WEIGHT_SECTION:", file=f)
        for ws in edge_weights:
            print(" ".join(map(str, [inf if w is None else w for w in ws])), file=f)
        print(f"EOF", file=f)

    with open(par_filename, "w") as f:
        print(f"PROBLEM_FILE = {tsp_filename}", file=f)
        print(f"OUTPUT_TOUR_FILE = {out_filename}", file=f)
        print("MOVE_TYPE = 5", file=f)
        print("PATCHING_C = 3", file=f)
        print("PATCHING_A = 2", file=f)
        print("RUNS = 10", file=f)

    subprocess.run(
        [
            "./LKH-3.0.10/LKH",
            par_filename,
        ],
        text=True,
        check=True,
    )

    tour = []
    in_tour_section = False
    with open(out_filename) as f:
        for line in f:
            if in_tour_section:
                if int(line) == -1:
                    break
                else:
                    tour.append(int(line))
            elif line.startswith("TOUR_SECTION"):
                in_tour_section = True
    assert len(tour) == dim

    # 1-origin to 0-origin
    tour = [i - 1 for i in tour]

    start_node_index = tour.index(start_node_id)
    tour = tour[start_node_index:] + tour[:start_node_index]
    assert tour[0] == start_node_id

    if tour[-1] == dummy_node_id:
        assert tour[-2] == sink_node_id
        tour.pop()
        tour.pop()
    elif tour[1] == dummy_node_id:
        assert tour[2] == sink_node_id
        tour = [start_node_id] + list(reversed(tour[3:]))
    else:
        assert False

    return [points[i - 1] for i in tour[1:]]


parser = argparse.ArgumentParser()
parser.add_argument("file", type=str, metavar="FILE", help="spaceship problem file")
parser.add_argument(
    "--output", "-o", type=str, metavar="FILE", required=True, help="output png file"
)
args = parser.parse_args()

points = []
with open(args.file) as f:
    for line in f:
        x, y = line.split()
        points.append((int(x), int(y)))

points2 = reorder(points)
with open(args.output, "w") as f:
    for p in points2:
        print(f"{p[0]} {p[1]}", file=f)
