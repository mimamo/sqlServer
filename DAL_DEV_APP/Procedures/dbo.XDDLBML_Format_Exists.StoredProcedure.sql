USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLBML_Format_Exists]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[XDDLBML_Format_Exists]
	@FormatID		varchar( 15 )
AS
	Declare	@SP	varchar( 30 )
	
	SET	@SP = 'dbo.XDDLBML_' + @FormatID
	if exists (select * from sysobjects where id = object_id(@SP) and sysstat & 0xf = 4)
		SELECT convert(int, 1)
	else
		SELECT convert(int, 0)
GO
