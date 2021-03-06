USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SetRIWhere_sp]    Script Date: 12/21/2015 14:06:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[SetRIWhere_sp] @ri_id smallint, @tablename varchar(30) = ""
AS
	DECLARE	@ri_where	varchar(255),
		@ri_replace	varchar(255),
		@temp		varchar(255),
		@pos		smallint,
		@column		varchar(255)

	/*
	**  Modify the where clause in RptRunTime to restrict
	**  by the RI_ID
	*/
	SELECT	@ri_where = "", @ri_replace = ""
	SELECT	@ri_where = ltrim(rtrim(RI_WHERE)),
		@ri_replace = ltrim(rtrim(RI_REPLACE))
	FROM	RptRunTime
	WHERE	ri_id = @ri_id
		/*
	**  Append a period to the table name, if supplied.
	*/
	IF @tablename <> ""
		SELECT	@column = " {"+ltrim(rtrim(@tablename)) + ".RI_ID} = "
	ELSE
		SELECT	@column = " {RI_ID} = "

	/*
	**  Parse and modify the where
	*/
	IF ltrim(rtrim(@ri_where)) <> ""
		SELECT	@ri_where = @ri_where + " AND "

	SELECT	@ri_where = @ri_where + @column +ltrim(rtrim(str(@ri_id)))

	/*
	**  Parse and modify the replace
	*/
	SELECT	@pos = patindex( '%>>%', @ri_replace )

	IF @pos = 0
	BEGIN
		SELECT	@ri_replace = "<<", @temp = ">>,"
	END

	ELSE
	BEGIN
		SELECT	@temp = substring( @ri_replace, @pos, 255 )
		SELECT	@ri_replace = substring( @ri_replace, 1, @pos-1 ) + " AND "
	END

	SELECT	@ri_replace = @ri_replace + @column + ltrim(rtrim(str(@ri_id))) + @temp

	/*
	**  Update the table
	*/
	UPDATE	RptRunTime
	SET	RI_WHERE = @ri_where,
		RI_REPLACE = @ri_replace
	WHERE	ri_id = @ri_id
GO
