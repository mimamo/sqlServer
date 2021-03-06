USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkccustinv_stax]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkccustinv_stax]   @custid1 as varchar(15), @custid2 varchar(15) as
select count(*) from customer C1, customer C2
where C1.custid = @custid1
and C2.custid = @custid2
and C1.taxid00 = C2.taxid00
and C1.taxid01= C2.taxid01
and C1.taxid02 = C2.taxid02
and C1.taxid03 = C2.taxid03
GO
