USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_0826_FROM_PJARPAY]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_0826_FROM_PJARPAY]  @CustId varchar(15)as
select * from pjarpay where
custid = @custid
order by custid
GO
