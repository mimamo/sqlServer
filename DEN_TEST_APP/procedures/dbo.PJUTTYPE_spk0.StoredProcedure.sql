USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTTYPE_spk0]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUTTYPE_spk0]  @parm1 varchar (4)   as
select * from PJUTTYPE
where    utilization_type = @parm1
order by utilization_type
GO
