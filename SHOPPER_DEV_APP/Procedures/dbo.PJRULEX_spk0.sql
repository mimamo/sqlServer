USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRULEX_spk0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRULEX_spk0] @parm1 varchar (16) , @parm2beg smallint , @parm2end smallint   as
select * from PJRULEX
where project =  @parm1 and
line_num  between  @parm2beg and @parm2end
order by project, line_num
GO
