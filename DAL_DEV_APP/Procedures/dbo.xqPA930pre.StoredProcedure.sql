USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xqPA930pre]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[xqPA930pre] 
@ri_id smallint 
as 
update rptruntime set longanswer00 = '12/31/2007' 
where ri_id = @ri_id 
and longanswer00 <= '0'
GO
