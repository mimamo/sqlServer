USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCompany_all]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[xCompany_all]
	@DBName varchar (30),
	@CpnyID varchar( 10 )
AS
	SELECT *
	FROM vs_Company
	WHERE Active = '1' and DatabaseName = @DBName and CpnyID LIKE @CpnyID 
	ORDER BY CpnyID
GO
