USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRULEX_spk1]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRULEX_spk1] @parm1 varchar (16)   as
select * from PJRULEX
where project =  @parm1
order by project, line_num
GO
