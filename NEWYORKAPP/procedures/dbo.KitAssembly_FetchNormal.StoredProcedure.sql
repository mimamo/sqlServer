USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[KitAssembly_FetchNormal]    Script Date: 12/21/2015 16:01:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[KitAssembly_FetchNormal]
	@InvtID varchar(30),
	@SiteID varchar(10)
as
	Select	l.WhseLoc,
		'LotSerNbr' = space(25),
		'QtyAvail' = (l.QtyAvail)

	From 	Location  l
	Join 	LocTable  lt
	  on	l.SiteID = lt.SiteID
	  and	l.WhseLoc = lt.WhseLoc
	Join	ItemSite  s
	  on	s.InvtID = l.InvtID
	  and	s.SiteID = l.SiteID

	Where 	l.InvtID = @InvtID
	  and 	l.SiteID = @SiteID
          and   lt.AssemblyValid = 'Y'
	  and	(l.QtyAvail + l.QtyAllocIN) > 0

	Order By
		Case When s.DfltPickBin = l.WhseLoc Then 0 Else 1 End,
		lt.PickPriority,
		QtyAvail
GO
