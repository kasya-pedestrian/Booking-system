/*
 * reservesimulator.c
 *
 *  Created on: 2022/01/26
 *      Author: new-kensyu
 */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<time.h>

#define FILELIST "list.txt"            /*対象リスト*/
#define FILESEAT "seat.txt"            /*座席状況*/
#define FILECUSTOMER "customer.txt"    /*予約番号管理*/
#define PRODUCTMAX 100
#define SEATMAX 300
#define RESERVEMAX 1000
#define DISPLAYMAX 24
#define SELECTMAX 5
#define CHARMAX 40

int select_product();
void seat_situation(int input);
int select_seat(int input);
int calculate_sum(int input, int count);
int pay_method(int sum);
void decision(int input, int count, int factor_c);
int issue_number();
void check_number(int check[]);
void cancel(int check[]);
int mode();

struct list {

	char product[CHARMAX];
	int value;
	int seat_x;
	int seat_y;

}list[PRODUCTMAX], sublist[SELECTMAX];       /*list : 対象情報　sulist : 選択座席*/

struct seat {
	int reserve;
	int number;
}seat[PRODUCTMAX][SEATMAX][SEATMAX]; /*座席状況*/

struct customer {
	int number;
	int paysum;
	char name[CHARMAX];
	char address[CHARMAX];
	int method;
	int pay;
} r_number[RESERVEMAX]; /*予約番号情報*/

int main(void) {
	FILE *fp_l, *fp_s, *fp_c;
	int mode_num, input, sum, count, decide;
	int check[3];
	int i, j, x, y;


	if ((fp_l = fopen(FILELIST, "r")) == NULL) {  /*ファイルオープン：読み込み*/
		printf("ファイルオープンエラー\n");
		fflush(stdout);
		exit(1);
	}

	if ((fp_s = fopen(FILESEAT, "r")) == NULL) {
		printf("ファイルオープンエラー\n");
		fflush(stdout);
		exit(1);
	}

	if ((fp_c = fopen(FILECUSTOMER, "r")) == NULL) {
		printf("ファイルオープンエラー\n");
		fflush(stdout);
		exit(1);
	}

	for (i = 0; i < PRODUCTMAX; i++) {   /*list 初期化*/
		fscanf(fp_l,"%s", list[i].product);
		if (list[i].product[0] == '0') {
			break;
		}
		fscanf(fp_l, "%d", &list[i].value);
		fscanf(fp_l, "%d", &list[i].seat_x);
		fscanf(fp_l, "%d", &list[i].seat_y);
	}

	for (j = 0; j < i; j++) { /*seat 初期化*/
		for (y = 0; y < list[j].seat_y; y++) {
			for (x = 0; x < list[j].seat_x; x++) {
				fscanf(fp_s, "%d", &seat[j][x][y].reserve);
				fscanf(fp_s, "%d", &seat[j][x][y].number);
			}
		}
	}

	for (i = 0; i < RESERVEMAX; i++) { /*r_number初期化*/
		fscanf(fp_c, "%d", &r_number[i].number);
		if (&r_number[i].number == (int)NULL) {
			break;
		}
		//printf("aaa\n");
		//fflush(stdout);
		fscanf(fp_c, "%d", &r_number[i].paysum);
		fscanf(fp_c, "%s", r_number[i].name);
		fscanf(fp_c, "%s", r_number[i].address);
		fscanf(fp_c, "%d", &r_number[i].method);
		fscanf(fp_c, "%d", &r_number[i].pay);
	}

	fclose(fp_l);
	fclose(fp_s);
	fclose(fp_c);


	while (1) {

		printf("操作を選択してください\n座席予約：1 予約キャンセル：2  終了：0\n");
		fflush(stdout);
		mode_num = mode();
		if (mode_num == 1) { /*座席予約*/
			input = select_product(); /*対象選択*/
			if(input == 0){
				continue;
			}
			seat_situation(input); /*座席状況表示*/
			count = select_seat(input); /*座席選択*/
			if(count == 0){
				continue;
			}
			sum = calculate_sum(input, count); /*支払金額計算*/
			decision(input, count, pay_method(sum)); /*支払方法選択、確定、実行*/
		}
		else if (mode_num == 2) { /*予約キャンセル*/
			decide = 0;
			check_number(check); /*予約番号確認*/
			while (1) {  /*バッファ処理*/
				if (getchar() == '\n') {
				break;
				}
			}

			if(check[0] == 0){
				continue;
			}

			while (1) {
				printf("キャンセルを確定：1 取消：2\n");
				fflush(stdout);
				scanf("%d", &decide);
				if (decide == 1) {
					cancel(check); /*キャンセル実行*/
					break;
				}
				else if (decide == 2) {
					break;
				}
				printf("エラー：もう一度入力し直して下さい\n");
				fflush(stdout);
			}

		}
		else if (mode_num == 0) { /*終了*/
			printf("操作を終了します\n");
			break;
		}
	}

	if ((fp_s = fopen( FILESEAT, "w")) == NULL) {/*ファイルオープン：書き込み*/
		fflush(stdout);
		fflush(stdout);
		printf("ファイルオープンエラー\n");
		exit(1);
	}

	if ((fp_c = fopen(FILECUSTOMER, "w")) == NULL) {
		fflush(stdout);
		printf("ファイルオープンエラー\n");
		exit(1);
	}

	for (j = 0; j < i; j++) { /*seat 書き込み*/
		for (y = 0; y < list[j].seat_y; y++) {
			for (x = 0; x < list[j].seat_x; x++) {
				fprintf(fp_s, "%d ", seat[j][x][y].reserve);
				fprintf(fp_s, "%d\n", seat[j][x][y].number);
			}
		}
	}

	for (i = 0; i < RESERVEMAX; i++) { /*r_number書き込み*/
		if (r_number[i].number == (int)NULL) {
			break;
		}
		fprintf(fp_c, "%d ", r_number[i].number);
		fprintf(fp_c, "%d ", r_number[i].paysum);
		fprintf(fp_c, "%s ", r_number[i].name);
		fprintf(fp_c, "%s ", r_number[i].address);
		fprintf(fp_c, "%d ", r_number[i].method);
		fprintf(fp_c, "%d\n", r_number[i].pay);
	}

	fclose(fp_s);
	fclose(fp_c);

	return 0;
}

int select_product() {

	int factor_s, input;

	printf("対象を選択してください\n");
	for (factor_s = 0; list[factor_s].product[0] != (char)NULL; factor_s++) { /*list 対象数*/
		if (list[factor_s].product[0] != '0') {
			printf("%d : %s  ", factor_s + 1, list[factor_s].product);
			printf("\\%d\n", list[factor_s].value);
			fflush(stdout);
		}
	}

	printf("0 : 取消\n");
	fflush(stdout);

	while(1){
		scanf("%d", &input);
		getchar();
		if(input <= factor_s){
			break;
		}
		printf("エラー：もう一度入力し直して下さい\n");
		fflush(stdout);
	}

	if(input == 0){
		return input;
	}

	fflush(stdout);
	printf(" %s ", list[input - 1].product);
	printf("\\%d\n\n", list[input - 1].value);

	return input;
}

void seat_situation(int input) {

	int x, y, count;
	x = 0;
	y = 0;
	count = 0;

	printf("  ");

	while (x < list[input - 1].seat_x) {
		if (list[input - 1].seat_x > DISPLAYMAX || list[input - 1].seat_y > DISPLAYMAX) {
			break;
		}
		printf("%2d", x + 1); /*列番号表示*/
		x++;
	}
	printf("\n");

	x = 0;
	while (y < list[input - 1].seat_y) {

		if (list[input - 1].seat_x < DISPLAYMAX + 1 && list[input - 1].seat_y < DISPLAYMAX + 1) {
			printf(" %c", y + 'A'); /*行記号表示*/
		}
		while (x < list[input - 1].seat_x) {
			if (seat[input - 1][x][y].reserve == 0) { /*予約前*/
				if (list[input - 1].seat_x < 25 && list[input - 1].seat_y < 25) {
					printf("□");
				}

				count++;
			}
			else { /*予約済*/
				if (list[input - 1].seat_x < DISPLAYMAX + 1 && list[input - 1].seat_y < DISPLAYMAX + 1) {
									printf("■");
				}
			}
			x++;
		}
		x = 0;
		if (list[input - 1].seat_x < DISPLAYMAX + 1 && list[input - 1].seat_y < DISPLAYMAX + 1) {
			 printf("\n");
		}

		y++;
	}

	if (list[input - 1].seat_x > DISPLAYMAX  || list[input - 1].seat_y > DISPLAYMAX) { /* x,y < 25*/
		count = 100 * count / (list[input - 1].seat_x * list[input - 1].seat_y);
		printf("空き状況：");
		fflush(stdout);
		if (count >= 70) {
			printf("◎\n");
		}
		else if (count < 70 && count >= 40) {
			printf("〇\n");
		}
		else if (count < 40 && count > 0) {
			printf("△\n");
		}
		else if (count == 0) {
			printf("×\n");
		}
	}
}

int select_seat(int input) {
	int select_x, select_y, count;
	int i;
	char select_xc[3] = {};
	char select_yc;
	count = 0;

	printf("\n");
	printf("座席選択(5席まで)\n");
	while (count < 5) {
		while (1) {

			printf("座席の行を入力してください（A～）(終了：enter 取消：0)\n");
			fflush(stdout);
			scanf("%c",&select_yc);
			//select_yc = getchar();
			if (select_yc == '\n') {
				return count;
			}
			else if (select_yc == '0') {
				for(i = 0; i < count; i++){
					seat[input - 1][sublist[i].seat_x][sublist[i].seat_y].reserve = 0;
					sublist[i].seat_x = (int)NULL;
					sublist[i].seat_y = (int)NULL;
				}
				while (1) {  /*バッファ処理*/
					if (getchar() == '\n') {
						break;
					}
				}
				return 0;
			}

			select_y = (int)select_yc - 'A'; /*文字入力から数値へ*/
			if (select_y >= 0 && select_y < list[input - 1].seat_y) {
				fflush(stdout);
				while (1) {
					if (getchar() == '\n') { /*バッファ処理*/
						break;
					}
				}
				break;
			}
			printf("エラー：もう一度入力し直して下さい\n");
			fflush(stdout);
			while (1) {  /*バッファ処理*/
				if (getchar() == '\n') {
					break;
				}
			}
		}
		while (1) {

			printf("座席の列を入力してください（1～）(終了：enter 取消：0)\n");
			fflush(stdout);
			scanf("%s",select_xc);

			if (select_xc[0] == '0') {
				for(i = 0; i < count; i++){
					seat[input - 1][sublist[i].seat_x][sublist[i].seat_y].reserve = 0;
					sublist[i].seat_x = (int)NULL;
					sublist[i].seat_y = (int)NULL;
				}
				while (1) {
					if (getchar() == '\n') {
						break;
					}
				}
				return 0;
			}
			else if (select_xc[0] == '\n') {
				getchar();
				return count;
			}
			else if((select_xc[1] == 0 && select_xc[2] != (char)NULL) || select_xc[0] >= 'A'){
				//printf("%d",select_xc[2]); /*デバック用*/
				printf("エラー：もう一度入力し直して下さい\n");
				fflush(stdout);
				while(1){
					if(getchar() == '\n'){
						break;
					}
				}
				continue;
			}

			if(select_xc[1] != (char)NULL){
				select_x = (select_xc[0] - 48) * 10 + (select_xc[1] - 48);
			}
			else{
				select_x = select_xc[0] - 48;
			}

			//printf("%d\n",select_x);/*デバック用*/
			if (select_x > 0 && select_x <= list[input - 1].seat_x) {

				while (1) {
					if (getchar() == '\n') {
						break;
					}
				}
				break;
			}
			printf("エラー：もう一度入力し直して下さい\n");
			fflush(stdout);
			while (1) {
				if (getchar() == '\n') {
					break;
				}
			}
		}

		if (seat[input - 1][select_x][select_y].reserve == 1){
			printf("この座席は予約済みです\n");
			fflush(stdout);
			continue;
		}

		seat[input - 1][select_x - 1][select_y].reserve = 2;
		sublist[count].seat_x = select_x - 1;
		sublist[count].seat_y = select_y ;

		count++;


	}

	return count;
}

int calculate_sum(int input, int count) {

	return count * list[input - 1].value;

}

int pay_method(int sum) {
	int factor_c;
	factor_c = 0;

	while (r_number[factor_c].method != (int)NULL) { /*予約管理リストの空き確認*/
		factor_c++;
	}

	while (1) {
		printf("支払方法を入力してください 振込：1　クレジットカード：2　取消：0\n");
		fflush(stdout);
		scanf("%d", &r_number[factor_c].method);
		if (r_number[factor_c].method == 0) {     /*取消判定*/
			r_number[factor_c].method = (int)NULL; /*入力情報初期化*/
			return -1;
		}
		else if (r_number[factor_c].method < 1 || r_number[factor_c].method > 2) { /*入力有効確認*/
			printf("エラー：もう一度入力し直して下さい\n");
			continue;
		}
		break;
	}

	printf("氏名を入力してください\n");
	fflush(stdout);
	scanf("%s", r_number[factor_c].name);
	if (r_number[factor_c].name[0] == '0') { /*取消判定*/
		r_number[factor_c].method = (int)NULL; /*入力情報初期化*/
		r_number[factor_c].name[0] = (char)NULL;
		return -1;
	}

	if (r_number[factor_c].method == 1) {
		printf("メールアドレスを入力してください\n");
		fflush(stdout);
	}
	else if (r_number[factor_c].method == 2) {
		printf("カード番号を入力してください\n");
		fflush(stdout);
	}

	scanf("%s", r_number[factor_c].address);
	if (r_number[factor_c].address[0] == '0') { /*取消判定*/
		r_number[factor_c].method = (int)NULL; /*入力情報初期化*/
		r_number[factor_c].name[0] = (char)NULL;
		r_number[factor_c].address[0] = (char)NULL;
		return -1;
	}

	r_number[factor_c].paysum = sum;
	r_number[factor_c].pay = 0;

	return factor_c;
}

void decision(int input, int count, int factor_c) {
	int decide;
	int number;
	int i;

	if ((r_number[factor_c].method < 1 && r_number[factor_c].method > 2) || factor_c < 0) { /*取消確認*/
		for(i = 0; i < count; i++){
			seat[input - 1][sublist[i].seat_x][sublist[i].seat_y].reserve = 0;
			sublist[i].seat_x = (int)NULL;
			sublist[i].seat_y = (int)NULL;
		}
		return;
	}

	printf("---------------------------------\n");
	printf("%s 様\n",r_number[factor_c].name);       /*氏名表示*/
	printf("予約対象：%s\n",list[input - 1].product); /*対象表示*/

	for(i = 0; i < count; i++){                       /*座席表示*/
		printf("座席(%d)：%c-%d\n", i + 1, sublist[i].seat_y + 'A', sublist[i].seat_x + 1);
	}

	printf("支払金額：\\%d\n",r_number[factor_c].paysum); /*支払金額表示*/

	if(r_number[factor_c].method == 1){              /*支払方法表示*/
		printf("支払方法：振込\n");
		printf("メールアドレス：%s\n",r_number[factor_c].address);
	}
	else if(r_number[factor_c].method == 2){
		printf("支払方法：クレジット\n");
	}
	printf("---------------------------------\n");

	while (1) {
		printf("1：予約確定　2：取り消し\n");
		fflush(stdout);
		scanf("%d", &decide);
		if (decide == 1) {
			number = issue_number(); /*予約番号発行*/
			for (i = 0; i < count; i++) {
				seat[input - 1][sublist[i].seat_x][sublist[i].seat_y].reserve = 1;     /*予約済*/
				seat[input - 1][sublist[i].seat_x][sublist[i].seat_y].number = number; /*予約番号*/
			}
			r_number[factor_c].number = number;
			printf("予約完了しました\n");
			printf("予約番号：%d\n", r_number[factor_c].number);
			printf("\n");
			break;
		}
		else if (decide == 2) { /*予約内容初期化*/
			r_number[factor_c].number = (int)NULL;
			r_number[factor_c].paysum = (int)NULL;
			r_number[factor_c].name[0] = (char)NULL;
			r_number[factor_c].address[0] = (char)NULL;
			r_number[factor_c].method = (int)NULL;
			r_number[factor_c].pay = (int)NULL;

			for (i = 0; i < count; i++) {
				seat[input - 1][sublist[i].seat_x][sublist[i].seat_y].reserve = 0; /*座席状況初期化*/
			}
			printf("取消しました\n");
			fflush(stdout);
			break;
		}

	}

}

int issue_number() {
	int number;

	srand((unsigned int)time(NULL));

	number = rand();
	number *= rand();
	number = rand() + (number % rand() * 100000);
	if (number < 0) {
		number = -number;
	}
	return number;
}

void check_number(int check[]) { /*予約番号初確認*/
	int number;
	int factor_s, factor_c; /*対象番号、予約番号管理リスト番号*/
	int pos_x, pos_y;
	int count; /*予約数*/

	count = 0;
	number = 0;
	printf("予約番号を入力してください(取消：0)\n");
	fflush(stdout);
	scanf("%d", &number);

	if(number == 0){
		check[0] = 0;
		return;
	}

	while (number < 0) {
		printf("予約番号を入力してください(取消：0)\n");
		fflush(stdout);
		scanf("%d", &number);

		if(number == 0){
			check[0] = 0;
			return;
		}
	}

	for (factor_s = 0; list[factor_s].product[0] != (char)NULL; factor_s++) { /*予約座席照合*/
		for (pos_y = 0; pos_y < list[factor_s].seat_y; pos_y++) {
			for (pos_x = 0; pos_x < list[factor_s].seat_x; pos_x++) {
				if (count == 5) {
					break;
				}
				if (number == seat[factor_s][pos_x][pos_y].number) {
					if (count == 0) {
						printf("%s\n 座席\n", list[factor_s].product);
						fflush(stdout);
						check[1] = factor_s;
					}
					sublist[count].seat_x = pos_x;
					sublist[count].seat_y = pos_y;
					printf("%c-%d\n", pos_y + 'A', pos_x + 1);
					fflush(stdout);
					count++;
				}
			}
			if (count == 5) {
				break;
			}
		}
		if (count == 5) {
			break;
		}
	}
	if(count == 0){
		printf("この番号は正しくありません");
		check[0] = count;
		return ;
	}
	for (factor_c = 0; r_number[factor_c].number != (int)NULL; factor_c++) { /*予約番号管理リスト照合*/
		if (number == r_number[factor_c].number) {
			printf("合計金額：\\%d\n", r_number[factor_c].paysum);
			fflush(stdout);
			break;
		}
	}

	check[0] = count;    /*座席数*/
	check[2] = factor_c; /*対象*/

}

void cancel(int check[]) {

	/*printf("%d ", check[0]);//デバック用
	printf("%d ", check[1]);
	printf("%d\n", check[2]);*/

	int count;

	if(check[0] == 0){
		return;
	}

	r_number[check[2]].number = (int)NULL;      /*予約番号初期化*/
	r_number[check[2]].paysum = (int)NULL;      /*支払金額初期化*/
	r_number[check[2]].name[0] = (char)NULL;    /*予約者名初期化*/
	r_number[check[2]].address[0] = (char)NULL; /*メールアドレス、カード番号初期化*/
	r_number[check[2]].method = (int)NULL;      /*支払方法初期化*/
	r_number[check[2]].pay = (int)NULL;         /*支払確認初期化*/

	for (count = 0; count < check[0]; count++) {
		seat[check[1]][sublist[count].seat_x][sublist[count].seat_y].reserve = 0;        /*予約状況初期化*/
		seat[check[1]][sublist[count].seat_x][sublist[count].seat_y].number = (int)NULL; /*予約番号初期化*/
	}
}

int mode() { /*モード選択*/

	int mode_num;


	while (1) {
		scanf("%d", &mode_num);
		if (mode_num == 1 || mode_num == 2 || mode_num == 0) {

			break;
		}
		printf("エラー：もう一度入力し直して下さい\n");
		fflush(stdout);
		getchar();
	}

	return mode_num;

}

