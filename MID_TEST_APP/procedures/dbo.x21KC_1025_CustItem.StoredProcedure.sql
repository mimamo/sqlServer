USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1025_CustItem]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1025_CustItem]  @invtid varchar(30),@custid varchar(15), @fiscyr varchar(4)   as      
select * from CustItem where 
invtid = @invtid
and custid = @custid
and fiscyr = @fiscyr
order by invtid
GO
