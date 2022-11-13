using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace _3de0.Migrations
{
    public partial class NewColumnsForCaff : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Title",
                table: "Files",
                newName: "Creator");

            migrationBuilder.AddColumn<string>(
                name: "Caption",
                table: "Files",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Caption",
                table: "Files");

            migrationBuilder.RenameColumn(
                name: "Creator",
                table: "Files",
                newName: "Title");
        }
    }
}
