USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1025_QtyOnHand]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1025_QtyOnHand] @invtid varchar(30)   as
declare   @tot float 
select @tot = max(qtyonhand) from location where invtid = @invtid
select @tot = @tot + max(qtyonhand) from itemsite where invtid = @invtid
select @tot = @tot + (1 * count(*)) from itemcost where invtid = @invtid
select @tot
GO
