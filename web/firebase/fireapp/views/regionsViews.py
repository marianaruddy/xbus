from django.shortcuts import render,redirect
from ..models import RegionModel
from ..forms import RegionForm

#Regions
def managementRegions(request):
        if not request.user.is_authenticated:
            return redirect('myLogin')
        regionModel = RegionModel()
        regions = regionModel.getAllRegions()

        context = {
                'regions': regions,
        }
        return render(request, 'Management/regions.html', context)

def managementRegionsAdd(request):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        form = RegionForm(request.POST)
        if form.is_valid():
            regionModel = RegionModel()
            post = form.save(commit=False)
            regionModel.createRegion(post)
        return redirect('managementRegions')
    else:
        form = RegionForm()
    return render(request, 'Management/regionsAdd.html', {'form': form})

def managementRegionsEdit(request, id):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        form = RegionForm(request.POST)
        if form.is_valid():
            regionModel = RegionModel()
            post = form.save(commit=False)
            regionModel.updateRegion(post)
        return redirect('managementRegions')
    else:
        regionModel = RegionModel()
        region = regionModel.getRegionById(id)
        form = RegionForm(instance=region)
    return render(request, 'Management/regionsAdd.html', {'form': form, 'id': id})

def deleteRegion(request, id):
        regionModel = RegionModel()

        regionModel.deleteRegionById(id)

        return redirect('managementRegions')
#End Regions