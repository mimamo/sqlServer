USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANWK_scheck]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANWK_scheck] @parm1 varchar(6) as
select * from PJTRANWK
where fiscalno <= @parm1
GO
