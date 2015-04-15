
void get_distribution(int distribution[], int nranks, int global_amount) {
    int base_amount = global_amount / nranks;
    int rest_amount = global_amount % nranks;

    int rests[nranks];


    for (int i = 0; i < nranks; ++i) {
        rests[i] = (i < rest_amount ? 1 : 0);
    }
    for (int i = 0; i < nranks; ++i) {
        distribution[i] = base_amount + rests[i];
    }
}
