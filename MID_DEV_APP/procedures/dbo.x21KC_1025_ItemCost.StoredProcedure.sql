USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1025_ItemCost]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1025_ItemCost]  @invtid varchar(30), @siteid varchar(10),@layertype varchar(2), @specificcostid varchar(25), @rcptnbr varchar(15), @rcptdate smalldatetime as 
select * from itemCost where 
invtid = @invtid
and siteid = @siteid
and layertype = @layertype
and specificcostid = @specificcostid
and rcptnbr = @rcptnbr
and rcptdate = @rcptdate
order by invtid
GO
