USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOPROJ_sinpe]    Script Date: 12/21/2015 15:49:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOPROJ_sinpe] @parm1 varchar (16) , @parm2 varchar (16)  as
select * from PJCOPROJ
where
project = @parm1 and
change_order_num like @parm2
and (status1 = 'I' or status1 = 'P')
order by project, change_order_num
GO
