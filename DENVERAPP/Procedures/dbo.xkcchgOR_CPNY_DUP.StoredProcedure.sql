USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcchgOR_CPNY_DUP]    Script Date: 12/21/2015 15:43:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc  [dbo].[xkcchgOR_CPNY_DUP]  @ordnbr varchar(15) as
select cpnyid from soheader
where ordnbr = @ordnbr
order by cpnyid, ordnbr
GO
