USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjemploy_scount]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjemploy_scount] @parm1 smalldatetime   as
select Count(*) from pjemploy
where   em_id08 = @parm1
GO
