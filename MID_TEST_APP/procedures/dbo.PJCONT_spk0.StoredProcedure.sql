USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONT_spk0]    Script Date: 12/21/2015 15:49:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONT_spk0] @parm1 varchar (16)  as
select * from PJCONT
where contract = @parm1
order by contract
GO
