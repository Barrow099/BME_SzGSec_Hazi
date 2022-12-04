using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace _3de0.Migrations
{
    public partial class AddedCaffFileIdToComment : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Comments_Files_CaffFileId",
                table: "Comments");

            migrationBuilder.AlterColumn<int>(
                name: "CaffFileId",
                table: "Comments",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Comments_Files_CaffFileId",
                table: "Comments",
                column: "CaffFileId",
                principalTable: "Files",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Comments_Files_CaffFileId",
                table: "Comments");

            migrationBuilder.AlterColumn<int>(
                name: "CaffFileId",
                table: "Comments",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Comments_Files_CaffFileId",
                table: "Comments",
                column: "CaffFileId",
                principalTable: "Files",
                principalColumn: "Id");
        }
    }
}
