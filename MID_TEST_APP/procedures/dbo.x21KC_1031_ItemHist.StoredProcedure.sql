USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_ItemHist]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_ItemHist]  @siteid varchar(10), @invtid varchar(30),@fiscyr char(6) as      
select * from itemHist where 
siteid = @siteid 
and invtid = @invtid
and fiscyr = @fiscyr
order by siteid
GO
