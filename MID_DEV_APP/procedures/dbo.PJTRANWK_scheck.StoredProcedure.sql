USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANWK_scheck]    Script Date: 12/21/2015 14:17:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANWK_scheck] @parm1 varchar(6) as
select * from PJTRANWK
where fiscalno <= @parm1
GO
