USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SD200_Search_smSvcEquip]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[SD200_Search_smSvcEquip]
		@parm1	varchar(100),		-- fieldname
		@parm2	varchar(100)		-- search values
AS
	DECLARE @szSQL			varchar(3000)
	DECLARE @szSelect		varchar(500)
	DECLARE @szWhere		varchar(500)
	DECLARE @szOrderBy		varchar(100)

	-- initialize
	SELECT @szSelect = ''
	SELECT @szWhere = ''
	SELECT @szOrderBy = ''

	SELECT @szSelect = ' SELECT * FROM smSvcEquipment (NOLOCK), SOAddress (NOLOCK), smSOAddress (NOLOCK)'
	SELECT @szWhere = ' WHERE SOAddress.CustID = smSvcEquipment.CustID AND
				SOAddress.ShiptoID = smSvcEquipment.SiteID AND
				smSOAddress.CustID = SOAddress.CustID AND
				smSOAddress.ShiptoID = SOAddress.ShiptoID AND ' +
				@parm1 + ' LIKE ' + QUOTENAME(@parm2,'''')

	SELECT @szOrderBy = ' ORDER BY smSvcEquipment.CustID, smSvcEquipment.SiteID'

	SELECT @szSQL = @szSelect + @szWhere + @szOrderBy

--PRINT (@szSQL)

	-- execute statement
	EXEC (@szSQL)
GO
