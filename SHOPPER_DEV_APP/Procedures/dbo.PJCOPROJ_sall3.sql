USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOPROJ_sall3]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOPROJ_sall3] @parm1 varchar (16) ,@parm2 varchar (16)  as
select * from PJCOPROJ
where
project = @parm1 and
change_order_num like @parm2
order by project, change_order_num
GO
