USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_SPK0]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_SPK0]  @parm1 varchar (10) , @parm2 smallint   as
select * from PJLABDET
where    docnbr     =  @parm1 and
linenbr = @parm2
order by docnbr, linenbr
GO
