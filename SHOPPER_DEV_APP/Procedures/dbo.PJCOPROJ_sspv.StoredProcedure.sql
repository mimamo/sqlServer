USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOPROJ_sspv]    Script Date: 12/21/2015 14:34:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOPROJ_sspv] @parm1 varchar (16) , @parm2 varchar (16)  as
select * from PJCOPROJ
where
project like @parm1 and
change_order_num like @parm2
order by project, change_order_num
GO
