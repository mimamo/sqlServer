USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCHARPAY_custid]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xCHARPAY_custid] @custid varchar(15) as
select distinct ardoc.custid, name from ardoc, customer  where
ardoc.custid like @custid
and doctype  in ('PA', 'NS', 'RP')
and ardoc.custid = customer.custid
order by ardoc.custid
GO
