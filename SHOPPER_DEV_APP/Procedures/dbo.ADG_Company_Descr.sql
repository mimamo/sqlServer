USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Company_Descr]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Company_Descr]
	@parm1 varchar(10)
	WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS

	declare @Query varchar(255)

	-- extra quote was missing
	select @Query = 'select CpnyName from vs_Company where CpnyID = ''' + @parm1 + ''' order by CpnyID'

	execute(@Query)
GO
