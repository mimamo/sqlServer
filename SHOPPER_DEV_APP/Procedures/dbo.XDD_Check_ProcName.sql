USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDD_Check_ProcName]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[XDD_Check_ProcName]
	@ProcName	varchar( 50 )		-- stored procedure name
AS

	declare @Query	varchar( 200 )
	
	SELECT	@Query = 'select count(*) from sysobjects where id = 
		object_id(''' + 'dbo.' + rtrim(@ProcName) + ''') and sysstat & 0xf = 4'
	
	-- Returns 1 if found proc
	-- Returns 0 if not	
	Execute(@Query)
GO
