USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARSETUP_SPK0NL]    Script Date: 12/21/2015 16:00:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARSETUP_SPK0NL] as
select * from ARSETUP (NOLOCK)
where    setupid = 'AR'
order by setupid
GO
