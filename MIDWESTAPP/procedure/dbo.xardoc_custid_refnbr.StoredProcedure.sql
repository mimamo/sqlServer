USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xardoc_custid_refnbr]    Script Date: 12/21/2015 15:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xardoc_custid_refnbr] @custid varchar(15), @refnbr varchar(10) as
select * from ardoc where 
custid = @custid 
and refnbr = @refnbr 
and doctype = 'IN' 
and rlsed = 1
GO
