USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_Spk3]    Script Date: 12/21/2015 15:37:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_Spk3] @parm1 varchar (10) ,@parm2 varchar (10)   as
select * from PJLABHDR
where    employee = @parm1 and
DOCNBR LIKE @parm2
	order by docnbr
GO
