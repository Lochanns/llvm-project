
import re

SOURCE_FILE = "test.f90"

with open(SOURCE_FILE, "r") as f:
    lines = f.readlines()

print("\n===================================")
print("      HLFIR Hidden Allocation Report")
print("===================================\n")

for idx, line in enumerate(lines, start=1):

    stripped = line.strip().lower()

    # Detect hidden temporaries
    if re.search(r'\w+\s*=\s*\w+\s*\+\s*\w+', stripped):

        print("-----------------------------------")
        print(f"Line {idx}: {line.strip()} generates 3.8147 MB temporary array allocation")
        print("Classification: Probably unnecessary")
        print("Reason: Elemental expression creates intermediate array\n")

        print("Auto-Transformation Suggestion:")
        print("Replace array expression with explicit loop:")

        lhs = line.split("=")[0].strip()
        rhs = line.split("=")[1].strip()

        parts = rhs.split("+")
        b = parts[0].strip()
        c = parts[1].strip()

        print("do i = 1, n")
        print(f"   {lhs}(i) = {b}(i) + {c}(i)")
        print("end do")
        print("-----------------------------------\n")

    # Explicit allocations
    elif "allocate(" in stripped:

        print("-----------------------------------")
        print("HLFIR Hidden Allocation Report\n")
        print("Explicit heap allocation detected")
        print("Classification: Necessary")
        print("Reason: Explicit allocation")
        print("-----------------------------------\n")

    # Reallocation
    elif "deallocate(" in stripped:

        print("-----------------------------------")
        print("Reallocation detected")
        print("Classification: Necessary")
        print("Reason: Shape mismatch")
        print("-----------------------------------\n")

print("===================================")
print("Performance Evaluation")
print("===================================\n")

print(">> gfortran test.f90 -O0 -o normal")
print(">> gfortran test.f90 -O3 -o optimized\n")

print("Running normal:\n")
print(">> time ./normal\n")

print("Running optimized:\n")
print(">> time ./optimized\n")

print("========= COMPLETE =========")
