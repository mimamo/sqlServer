USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARSETUP_SPK0NL]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARSETUP_SPK0NL] as
select * from ARSETUP (NOLOCK)
where    setupid = 'AR'
order by setupid
GO
