A = atan(0.75); // 36.81°
B = (270 - A) / 2; // 116.57°

fn=100;
$fn=fn;

//r   ..  r+d
//R-r-d ..  R-r

width = 0.8;
r = 6;

overlap = 0.01;

R = 2 * r + width;

sp_r = r * (1+2*sqrt(5)) + width * sqrt(5);


module arc(radius, angles) {
    difference() {
        circle(radius + width, $fn = fn);
        circle(radius, $fn = fn);
        sector_to_cut(radius + width, angles);
    };
}

module sector_to_cut(radius, angles) {
    if (angles[1]-angles[0] <= 180)
    {
        union() {
            rotate(angles[0], [0, 0, 1]) translate([0, -2*radius - overlap, 0]) square(size =  4*radius    , center = true);
            rotate(angles[1], [0, 0, 1]) translate([0, 2*radius + overlap,0]) square(size =  4*radius    , center = true);
        };
    } else {
        intersection() {
            rotate(angles[0], [0, 0, 1]) translate([0, -radius - overlap, 0]) square(size = 2*radius    , center = true);
            rotate(angles[1], [0, 0, 1]) translate([0, radius + overlap,0]) square(size = 2*radius    , center = true);
        };
    }
}

module torus(outer_radius, outer_angle, inner_radius, inner_angles) {
    rotate(overlap / outer_radius, [0, 0, 1])
        rotate_extrude(angle=outer_angle + 2*overlap/outer_radius)
            translate([outer_radius, 0, 0])
                arc(inner_radius, inner_angles);
}

module pastel_green() {
    color([0.6, 1, 0.6])
    torus(R, 180, r, [-90, 180]);
}
module yellow() {
    color([1, 1, 0])
    translate([-R, 0, 0]) rotate(-A, [0, 1, 0]) translate([R, 0, 0])
    rotate(180, [0, 0, 1])
    torus(R, 90, r, [180-B, 180]);
}

module cone_yellow() {
    rotate(180, [0, 0, 1])
        translate([-R, 0, R])
    translate([-R, 0, 0]) rotate(-A, [0, 1, 0]) translate([R, 0, 0])
    rotate(180, [0, 0, 1])
    union() {
        cylinder(h=R, r1 = R - overlap/1.5, r2 = 1.5*R- overlap/1.5);
        difference() {
            cube(10*R, center = true);
            cube(5.01*R);
        }
    }
}

module saturated_green() {
    color([0, 1, 0])
    translate([2*R, 0, R])
    rotate(90, [0, 0, 1])
    rotate(120, [1, 1, 1])
    torus(R, A , r, [90, 180]);
}

module red() {
    color([1, 0, 0])
    translate([0, 0, R])
    torus(2*R, A, r, [-90, -90+B]);
}

module cone_red() {
    translate([0, 0, R])
    cylinder(h=2*R, r1 = 2*R, r2 = 6*R);
}

module purple() {
    color([1, 0, 1]) translate([0, 0, -R - overlap])
        linear_extrude(height=R + 2*overlap)
            arc(radius = r, angles = [0, 270]);
}

module plate() {
    translate([0, 0, r-R])
    rotate(-90, [0, 0, 1])
    linear_extrude(height=width) {
        difference() {
            intersection() {
                union() {
                    circle(R);
                    square(R);
                    translate([0, -R]) square([2*R, R]);
                };
                translate([0, R]) circle(2*R);
            };
            translate([2*R, 0]) circle(R);

            // hole for pipe
            circle(r+width-overlap);
            square(r+width-overlap);
        };
    }
}

module tuyeau() {
    rotate(180, [0, 0, 1])
        translate([-R, 0, R]) {
            pastel_green();
            yellow();
            purple();
    plate();
        }
        saturated_green();
    red();
}

module chapeau_1() {
    color([0, 1, 1])
    intersection() {
        difference() {
            sphere(sp_r+width);
            sphere(sp_r);
        }
        cone_red();
        rotate(120, [1, 1, 1]) cone_red();
        rotate(-120, [1, 1, 1]) cone_red();
    }
}

module chapeau_2() {
    color([0, 1, 1])
    intersection() {
        difference() {
            sphere(sp_r+width);
            sphere(sp_r);
            rotate(-120, [1, 1, 1]) cone_red();
            cone_yellow();
        }
        rotate(0, [1, 1, 1]) cone_red();
    }
}

module chapeau() {
    $fn=2*fn;
    union() {
        chapeau_1();
        chapeau_2();
        rotate(120, [1, 1, 1]) chapeau_2();
        rotate(-120, [1, 1, 1]) chapeau_2();
    }
};

module boy() {
    tuyeau();
    rotate(120, [1, 1, 1]) tuyeau();
    rotate(-120, [1, 1, 1]) tuyeau();
//    rotate(180, [1, 1, 1]) tuyeau();
    chapeau();
}

rotate(180-atan(1/sqrt(2)), [0, 1, 0]) rotate(45, [1, 0, 0])
    boy();

//1 1 1

//1
//  c -s
//  s  c

//1 0 sqrt(2)

//c    -s
//   1
//s     c
//cos - sqrt(2)*sin = 0
//tan = 1/sqrt(2)


//1 1 1
//1 -1 0
//1 1 -2
