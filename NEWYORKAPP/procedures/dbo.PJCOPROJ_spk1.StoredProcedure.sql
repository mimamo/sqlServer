USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOPROJ_spk1]    Script Date: 12/21/2015 16:01:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOPROJ_spk1] @parm1 varchar (16) , @parm2 varchar (16)  as
select * from PJCOPROJ
where project = @parm1 and
change_order_num = @parm2
order by PJCOPROJ.project, PJCOPROJ.change_order_num
GO
