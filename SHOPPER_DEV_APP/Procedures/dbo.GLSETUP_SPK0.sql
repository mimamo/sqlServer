USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLSETUP_SPK0]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[GLSETUP_SPK0] as
select * from GLSETUP
where    setupid = 'GL'
order by setupid
GO
