USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcchgSH_CPNY_DUP]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc  [dbo].[xkcchgSH_CPNY_DUP]  @shipperid varchar(15) as
select cpnyid from soshipheader
where shipperid = @shipperid
order by cpnyid, shipperid
GO
