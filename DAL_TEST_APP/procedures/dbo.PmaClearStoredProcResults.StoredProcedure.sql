USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PmaClearStoredProcResults]    Script Date: 12/21/2015 13:57:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PmaClearStoredProcResults]
	@Guid UNIQUEIDENTIFIER
AS
BEGIN
	DELETE FROM StoredProcedureResultSet WHERE ID=@Guid
END
GO
